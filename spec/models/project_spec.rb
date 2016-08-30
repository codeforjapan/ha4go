require 'rails_helper'

describe Project, 'validation' do
  it { should validate_presence_of :subject }
end
describe Project, 'association' do
  it { should have_many(:project_updates) }
  it { should belong_to(:user) }
  it { should have_and_belong_to_many(:users) }
  it { should have_and_belong_to_many(:skills) }
  it { should belong_to(:stage) }
end
describe Project, 'editable_user_id' do
  pending 'Omniauth の認証をここでしなくてはいけない'
  let(:project) {create(:project)}
end
describe Project, 'update_skill_ids_by_skill_names' do
  let(:project) {create(:project)}
  let(:project_with_skills) {create(:project_with_skills)}
  it 'has skills' do
    expect{project_with_skills}.to change{Skill.count}.by 3
  end
  it 'should update skill names' do
    expect{project.update_skill_ids_by_skill_names(%w('rails javascript ruby rspec'))}.to change{Skill.count}.by 4
    expect(project.skills.count).to equal 4
  end
  it 'shoud create new skill if there is no skill' do
    pending 'write this later'
    expect{project_with_skills.update_skill_ids_by_skill_names(%w('rails ruby'))}.to change{Skill.count}.by 0
  end
end
