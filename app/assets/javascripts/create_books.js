$(document).on("turbolinks:load", function() {
  function createBook(status) {
    $.ajax({
      url: "/books",
      method: "post",
      data: {
        book: {
          title: $("#read-book").data("title"),
          authors: $("#read-book").data("authors"),
          image_url: $("#read-book").data("image"),
          uid: $("#read-book").data("uid")
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

  $("#reading-book").on("click", function() {
    createBook(1);
  });

  $("#will-read-book").on("click", function() {
    createBook(2);
  });
});
