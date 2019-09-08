$(function() {
  function createBook(status) {
    let title = $("#readBook").data("title");
    let authors = $("#readBook").data("authors");
    let image_url = $("#readBook").data("image");
    let uid = $("#readBook").data("uid");
  }

  $("#readingBook").on("click", function() {
    createBook(1);
  });

  $("#willReadBook").on("click", function() {
    createBook(2);
  });
});
