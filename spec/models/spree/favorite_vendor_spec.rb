# == Schema Information
#
# Table name: spree_favorite_vendors
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#  vendor_id  :bigint           not null
#
# Indexes
#
#  index_spree_favorite_vendors_on_user_id    (user_id)
#  index_spree_favorite_vendors_on_vendor_id  (vendor_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => spree_users.id)
#  fk_rails_...  (vendor_id => spree_vendors.id)
#
require 'rails_helper'

RSpec.describe Spree::FavoriteVendor, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:vendor).class_name('Spree::Vendor').with_foreign_key(:vendor_id) }
    it { is_expected.to belong_to(:user).class_name('Spree::User').with_foreign_key(:user_id) }
  end

  describe 'validations' do
    subject { build(:favorite_vendor) }

    it { is_expected.to validate_uniqueness_of(:vendor_id).scoped_to(:user_id) }
  end

  describe '.favorites_for_user' do
    subject { described_class.favorites_for_user(user) }

    let(:user) { create(:user) }
    let(:vendor) { create(:vendor) }
    let!(:favorite_vendor) { create(:favorite_vendor, user: user, vendor: vendor) }

    it { is_expected.to eq([vendor]) }
  end

  describe '.favorite?' do
    subject { described_class.favorite?(vendor, user) }

    let(:user) { create(:user) }
    let(:vendor) { create(:vendor) }

    context 'when favorite vendor exists' do
      let!(:favorite_vendor) { create(:favorite_vendor, user: user, vendor: vendor) }

      it { is_expected.to eq(true) }
    end

    context 'when favorite vendor does not exist' do
      it { is_expected.to eq(false) }
    end
  end

  describe '.favorite' do
    subject { described_class.favorite(vendor, user) }

    let(:user) { create(:user) }
    let(:vendor) { create(:vendor) }

    it { is_expected.to be_a(described_class) }
  end

  describe '.unfavorite' do
    subject { described_class.unfavorite(vendor, user) }

    let(:user) { create(:user) }
    let(:vendor) { create(:vendor) }
    let!(:favorite_vendor) { create(:favorite_vendor, user: user, vendor: vendor) }

    it { is_expected.to eq([favorite_vendor]) }
  end

  describe '.toggle_favorite' do
    subject { described_class.toggle_favorite(vendor, user) }

    let(:user) { create(:user) }
    let(:vendor) { create(:vendor) }

    context 'when favorite vendor exists' do
      let!(:favorite_vendor) { create(:favorite_vendor, user: user, vendor: vendor) }

      it { is_expected.to eq([favorite_vendor]) }
    end

    context 'when favorite vendor does not exist' do
      it { is_expected.to be_a(described_class) }
    end
  end
end
