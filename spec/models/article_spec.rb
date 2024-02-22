require 'rails_helper'

RSpec.describe Article, type: :model do
  describe '#validations' do
    let(:article) { build(:article) }

    it "tests that factory is valid" do
      expect(article).to be_valid
    end

    it 'has an invalid title' do
      article.title = ''
      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end

    it 'has an invalid content' do
      article.content = ''
      expect(article).not_to be_valid
      expect(article.errors[:content]).to include("can't be blank")
    end

    it 'has an invalid slug' do
      article.slug = ''
      expect(article).not_to be_valid
      expect(article.errors[:slug]).to include("can't be blank")
    end
  end

  describe '.recent' do
    let!(:older_article) { create(:article, created_at: 1.hour.ago) }
    let!(:recent_article) { create(:article) }

    it 'returns articles by created_at in descending order' do
      expect(described_class.recent).to eq(
        [recent_article, older_article]
      )
    end

    it 'maintains the order when articles are updated' do
      recent_article.update_column(:created_at, 1.hours.ago)
      expect(described_class.recent).to eq(
        [recent_article, older_article]
      )
    end
  end
end
