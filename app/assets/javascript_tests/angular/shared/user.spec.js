describe("User", function() {
  var User,
      $window;

  beforeEach(inject((_User_, _$window_) => {
    User = _User_;
    $window = _$window_;
  }));

  describe("getUser", function() {
    it("returns $window.current_user", () => {
      $window.current_user = "test";
      expect(User.getUser()).toEqual("test");
    });

    it("works without $window.current_user set", () => {
      delete $window.current_user;
      expect(User.getUser()).not.toBeDefined();
    });
  });

  describe("isLoggedIn", function() {
    it("returns true when $window.current_user", () => {
      $window.current_user = "test";
      expect(User.isLoggedIn()).toEqual(true);
    });

    it("works without $window.current_user set", () => {
      delete $window.current_user;
      expect(User.isLoggedIn()).toEqual(false);
    });
  });
});
