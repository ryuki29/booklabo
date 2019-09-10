$(document).on("turbolinks:load", function() {
  function createBook(status) {
    $.ajax({
      url: "/books",
      method: "post",
      data: {
        book: {
          title: $("#read-book").attr("data-title"),
          authors: $("#read-book").attr("data-authors"),
          image_url: $("#read-book").attr("data-image"),
          uid: $("#read-book").attr("data-uid")
        },
        user_book: {
          status: status
        }
      },
      dataType: "json"
    })
      .done(function(data) {
        let url = "/users/" + data.user_id + "?status=" + data.book_status;
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

  $("#review-submit").on("click", function() {
    $("#review-submit").prop("disabled", true);

    $.ajax({
      url: "/books",
      method: "post",
      data: {
        book: {
          title: $("#read-book").attr("data-title"),
          authors: $("#read-book").attr("data-authors"),
          image_url: $("#read-book").attr("data-image"),
          uid: $("#read-book").attr("data-uid")
        },
        user_book: {
          status: 0
        },
        review: {
          date: $("#date-input").val(),
          text: $("#review-text").val(),
          rating: $("#book-rating").val()
        }
      },
      dataType: "json"
    })
      .done(function(data) {
        let url = "/users/" + data.user_id + "?status=" + data.book_status;
        window.location.replace(url);
      })
      .fail(function() {
        alert("エラーが発生しました");
      });
  });
});
