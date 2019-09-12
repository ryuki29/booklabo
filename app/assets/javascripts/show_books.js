$(document).on("turbolinks:load", function() {
  function buildHTML(book, status) {
    var modal = status === 0 ? "#show-review-modal" : "#post-book-modal";
    var html = `
    <div class="users-show-items card col-sm-3 border-0">
      <img id="${book.id}" class="users-show-book-img" src="${book.image_url}" data-toggle="modal" data-target="${modal}" data-title="${book.title}" data-authors="${book.authors}" data-image="${book.image_url}" data-uid="${book.uid}" data-status="${status}">
      <div class="card-body">
        <h5 class="card-title">
          ${book.title}
        </h5>
        <div class="card-text">
          ${book.authors}
        </div>
      </div>
    </div>`;
    return html;
  }

  function setRating(review) {
    let rating = "#rating-" + review.rating;
    $("#review-show-rating .fa-star").css("color", "#ddd");
    $("#review-show-rating")
      .find(rating)
      .css("color", "#fc0")
      .prevAll()
      .css("color", "#fc0");
  }

  function removeBookFromList(id) {
    let deletedBookId = "#" + id;
    $(".users-show-items")
      .find(deletedBookId)
      .parent()
      .remove();
  }

  $(".users-show-nav-item").on("click", function() {
    let status = $(this).data("status");

    if (!$(this).hasClass("active")) {
      $(".user-show-nav")
        .children(".active")
        .removeClass("active");
      $(this).addClass("active");

      $(".users-show-items").remove();
      $.ajax({
        url: "/books/fetch",
        type: "get",
        data: {
          status: status
        },
        dataType: "json"
      })
        .done(function(data) {
          data.forEach(function(book) {
            let html = buildHTML(book, status);
            $("#user-show-item-list").append(html);
          });
        })
        .fail(function() {
          alert("エラーが発生しました");
        });
    }
  });

  if ($(".user-show-nav").length) {
    let status = Number($(".user-show-nav").data("status"));

    switch (status) {
      case 0:
        $("#read").addClass("active");
        break;
      case 1:
        $("#reading").addClass("active");
        break;
      case 2:
        $("#will-read").addClass("active");
        break;
    }
  }

  $("#user-show-item-list").on("click", ".users-show-book-img", function() {
    let title = $(this).attr("data-title");
    let authors = $(this).attr("data-authors");
    let image = $(this).attr("data-image");
    let uid = $(this).attr("data-uid");
    let id = $(this).attr("id");
    let status = $(this).attr("data-status");

    if (status === "1" || status === "2") {
      if (status === "1") {
        $("#will-read-book").removeClass("btn-selected");
        $("#will-read-book")
          .find("span")
          .text("読みたい本に追加");

        $("#reading-book").addClass("btn-selected");
        $("#reading-book")
          .find("span")
          .text("読んでる本から解除");
      }

      if (status === "2") {
        $("#reading-book").removeClass("btn-selected");
        $("#reading-book")
          .find("span")
          .text("読んでる本に追加");

        $("#will-read-book").addClass("btn-selected");
        $("#will-read-book")
          .find("span")
          .text("読みたい本から解除");
      }

      $("#modal-book-img").attr("src", image);
      $("#modal-book-title").text(title);
      $("#modal-book-author").text(authors);

      $("#read-book")
        .attr("data-title", title)
        .attr("data-authors", authors)
        .attr("data-image", image)
        .attr("data-uid", uid)
        .attr("data-id", id);

      $("#post-review-img").attr("src", image);
      $("#read-bookTitle").attr("value", title);
      $("#read-bookAuthors").attr("value", authors);
      $("#read-bookImage").attr("value", image);
      $("#read-bookUid").attr("value", uid);
    } else {
      $("#book-title").text(title);
      $("#book-authors").text(authors);
      $("#book-img").attr("src", image);
      $("#delete-read-book").attr("data-id", id);

      let url = "/books/" + id + "/review";
      $.ajax({
        url: url,
        type: "get",
        dataType: "json"
      })
        .done(function(review) {
          $("#review-show-date").text(review.date);
          $("#review-show-text").text(review.text);
          $("#review-show-rating").attr("data-rating", review.rating);
          setRating(review);
        })
        .fail(function() {
          alert("エラーが発生しました");
        });
    }
  });

  if ($(".user-show").length) {
    $(".modal-footer").on("click", ".btn-selected", function() {
      let id = $("#read-book").attr("data-id");
      let selectedButton = $(this);
      let status = $(this).attr("data-status");

      $.ajax({
        url: "/books/" + id,
        type: "delete",
        dataType: "json"
      })
        .done(function() {
          selectedButton.removeClass("btn-selected");
          removeBookFromList(id);

          if (status === "1") {
            selectedButton.find("span").text("読んでる本に登録");
          } else {
            selectedButton.find("span").text("読みたい本に登録");
          }
        })
        .fail(function() {
          alert("エラーが発生しました");
        });
    });
  }

  $("#delete-read-book").on("click", function() {
    if (!confirm("本当に削除しますか？")) {
      return false;
    } else {
      let id = $(this).attr("data-id");

      $.ajax({
        url: "/books/" + id,
        type: "delete",
        dataType: "json"
      })
        .done(function() {
          removeBookFromList(id);
          $("#show-review-modal").modal("hide");
        })
        .fail(function() {
          alert("エラーが発生しました");
        });
    }
  });

  $("#edit-review").on("click", function() {
    $(".post-review-title").text("レビューを編集する");
    $("#review-submit").text("更新する");

    let image = $("#book-img").attr("src");
    $("#post-review-img").attr("src", image);

    let initial_date = $("#review-show-date").text();

    if (initial_date !== "") {
      $("#date-check").prop("checked", false);
      $("#date-input, #calender")
        .attr("disabled", false)
        .removeClass("form-disabled");
      $("#date-input").val(initial_date);
    } else {
      $("#date-check").prop("checked", true);
      $("#date-input, #calender")
        .attr("disabled", true)
        .addClass("form-disabled");
    }

    let initial_text = $("#review-show-text").text();
    $("#word-count").text(initial_text.length);
    $("#review-text").val(initial_text);

    let initial_rating = $("#review-show-rating").attr("data-rating");
    $("#book-rating").val(initial_rating);
    $("#review-post-rating .fa-star").removeClass("star-active");
    let selector = `#review-post-rating .fa-star:nth-child(${initial_rating})`;
    $(selector)
      .addClass("star-active")
      .prevAll()
      .addClass("star-active");
  });
});
