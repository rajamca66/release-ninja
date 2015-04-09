RSpec.feature "Subdomain Routes", :type => :feature do
  scenario "with www" do
    Capybara.default_host = "http://www.example.com"
    visit "/"
    expect(page.status_code).to eq(200)
  end

  scenario "with herokuapp base" do
    Capybara.default_host = "http://test.herokuapp.com"
    visit "/"
    expect(page.status_code).to eq(200)
  end
end
