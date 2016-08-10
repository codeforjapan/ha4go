FactoryGirl.define do
  factory :project do
    id 1
    subject "My awesome project"
    after(:create) do |project|
      10.times do |i|
        create(:project_update, description:"meeting#{i}}", project: project)
      end
    end
    factory :project_with_skills do
      after(:create) do |project|
        project.skills << create(:skill1)
        project.skills << create(:skill2)
        project.skills << create(:skill3)
      end
    end
  end
  factory :project_update do
    description 'initial'
  end
end
