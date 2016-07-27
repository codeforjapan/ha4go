FactoryGirl.define do
  factory :project do
    subject "My awesome project"
    after(:create) do |project|
      10.times do |i|
        create(:project_update, description:"meeting#{i}}", project: project)
      end
    end
  end
  factory :project_update do
    description 'initial'
  end
end
