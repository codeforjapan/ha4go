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
