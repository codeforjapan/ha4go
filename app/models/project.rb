# coding: utf-8
class Project < ActiveRecord::Base
  validates :subject, presence: true
  has_many :project_updates
  belongs_to :user
  has_and_belongs_to_many :users
  has_and_belongs_to_many :skills
  belongs_to :stage

  scope :recent, lambda { |before|
    joins(:project_updates).where('project_updates.created_at > ?', before).group(:project_id)
  }

  scope :hot_rank, lambda { |before|
    keys = joins(:project_updates).where(ProjectUpdate.arel_table[:created_at].gt(before)).group(ProjectUpdate.arel_table[:project_id]).order('count_project_updates_project_id desc').count('project_updates.project_id').keys
    records = Project.find(keys).index_by(&:id)
    out = []
    keys.each do |k|
      out << records[k]
    end
    out
  }

  # プロジェクトを編集可能なユーザーかどうか
  # @param [Integer] user_id
  # @return [Boolean]
  def editable_user_id?(user_id)
    if user_id == self.user_id
      return true
    else
      return false
    end
  end

  # 必要なスキルを更新
  # @param [Array] skill_names スキル名の配列
  # @return [Boolean]
  def update_skill_ids_by_skill_names(skill_names)
    @before_skill_ids = skills.map(&:id)
    @after_skill_ids  = []
    skill_names.compact.uniq.reject(&:empty?).each do |skill_name|
      skill = Skill.find_by(name: skill_name)
      if skill.nil?
        skill = Skill.create(name: skill_name)
      end
      @after_skill_ids.push(skill.id)
    end

    # 追加
    (@after_skill_ids - @before_skill_ids).each do |skill_id|
      skills << Skill.find(skill_id)
    end

    # 削除
    (@before_skill_ids - @after_skill_ids).each do |skill_id|
      skills.delete(skill_id)
    end
  end

  # メールを送るユーザーを取得
  def send_mail_users
    send_users = users
    me = user

    # 自分がいない場合には含める
    if send_users.select { |u| u['user_id'] == me['user_id'] }.empty?
      send_users.push me
    end
    send_users
  end
end
