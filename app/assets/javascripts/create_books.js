$(function() {
  function createBook(status) {
    let title = $("#readBook").data("title");
    let authors = $("#readBook").data("authors");
    let image_url = $("#readBook").data("image");
    let uid = $("#readBook").data("uid");

    $.ajax({
      url: "/books",
      type: "POST",
      data: {
        book: {
          title: $("#readBook").data("title"),
          authors: $("#readBook").data("authors"),
          image_url: $("#readBook").data("image"),
          uid: $("#readBook").data("uid")
        },
        user_book: {
          status: status
        }
      },
      dataType: "json"
    });
  }

  $("#readingBook").on("click", function() {
    createBook(1);
  });

  $("#willReadBook").on("click", function() {
    createBook(2);
  });
});
