(function(app) {
  app.service("SideMenu", function() {
    var items = [];
    var service = {
      getItems: getItems,
      addItem: addItem,
      clear: clearItems
    };
    return service;

    function getItems() {
      return items;
    }

    function clearItems() {
      items = [];
      return service;
    }

    function addItem(title, onClick) {
      items.push({ title, onClick: onClick });
      return service;
    }
  });
})(angular.module("app"));
