$(function() {
  function createBook(status) {
    $.ajax({
      url: "/books",
      method: "post",
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
    })
      .done(function(data) {
        let url = "/users/" + data.user_id + "?status=" + data.status;
        window.location.replace(url);
      })
      .fail(function() {
        alert("エラーが発生しました");
      });
  }

  $("#readingBook").on("click", function() {
    createBook(1);
  });

  $("#willReadBook").on("click", function() {
    createBook(2);
  });
});
