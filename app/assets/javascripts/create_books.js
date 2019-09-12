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
    if (!$(this).hasClass("btn-selected")) {
      createBook(1);
    }
  });

  $("#will-read-book").on("click", function() {
    if (!$(this).hasClass("btn-selected")) {
      createBook(2);
    }
  });

  $("#review-submit").on("click", function() {
    if ($("#review-submit").text() === "登録する") {
      $(this).prop("disabled", true);

      $.ajax({
        url: url,
        method: method,
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
          let url = "/users/" + data.user_id;
          window.location.replace(url);
        })
        .fail(function() {
          alert("エラーが発生しました");
        });
    }
  });

  $("#review-submit").on("click", function() {
    if ($("#review-submit").text() === "更新する") {
      $(this).prop("disabled", true);
      let id = $("#delete-read-book").attr("data-id");
      let url = `/books/${id}/review`;

      $.ajax({
        url: url,
        method: "put",
        data: {
          review: {
            date: $("#date-input").val(),
            text: $("#review-text").val(),
            rating: $("#book-rating").val()
          }
        },
        dataType: "json"
      })
        .done(function(data) {
          let url = "/users/" + data.user_id;
          window.location.replace(url);
        })
        .fail(function() {
          alert("エラーが発生しました");
        });
    }
  });
});
