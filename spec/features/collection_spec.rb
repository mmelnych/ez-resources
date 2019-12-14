require 'rails_helper'

RSpec.describe 'Collection' do
  subject { page }

  let!(:user_a) { create(:user) }
  let!(:user_b) { create(:user) }

  def ez_divs(divs)
    divs.split(', ').map { |div| ".ez-resources-#{div}" }.join(' > ')
  end

  it 'render collection table' do
    visit '/users'

    within ez_divs('container, inner-container, top-container, header-container, header-inner-container') do
      is_expected.to have_content 'Users (2)'
    end

    within ez_divs('container, inner-container, top-container, actions-container, actions-inner-container') do
      is_expected.to have_link 'Add', href: '/users/new'
    end

    # Has table headers
    %w[email age active notes].each do |col_name|
      within "th#ez-t-#{col_name}" do
        is_expected.to have_content(col_name)
      end
    end

    # Has table content
    [user_a, user_b].each do |user|
      %w[email age active notes].each do |col_name|
        within "tr#users-#{user.id} > td.ez-t-#{col_name}" do
          is_expected.to have_content(user.public_send(col_name))
        end
      end
    end
  end
end
