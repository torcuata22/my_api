require 'rails_helper'

RSpec.describe Article, type: :model do
  #check if number is positive
  it "tests article object" do
    article=create(:article)
    expect(article.title).to eq('Sample Article')
  end
end
