RSpec.feature "Subdomain Routes", :type => :feature do
  scenario "with www" do
    Capybara.app_host = "http://www.test.host"
    visit "/"
    expect(page.status_code).to eq(200)
  end

  scenario "with herokuapp base" do
    # Simulate what happens on release-ninja.herokuapp.com. The subdomains is just release-ninja, and the domain is
    # herokuapp.com. Can't seem to get this setup locally, so just going to fake it
    Capybara.app_host = "http://sub.release-ninja.herokuapp"
    visit "/"
    expect(page.status_code).to eq(200)
  end
end
