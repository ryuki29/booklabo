$(document).on("turbolinks:load", function() {
  function buildHTML(book, status) {
    var html = `
    <div class="users-show-items card col-sm-3 border-0">
      <img id="${book.id}" class="users-show-book-img" src="${book.image_url}" data-toggle="modal" data-target="#post-book-modal" data-title="${book.title}" data-authors="${book.authors}" data-image="${book.image_url}" data-uid="${book.uid}" data-status="${status}">
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
          console.log($(this)[0]);
          selectedButton.removeClass("btn-selected");

          let deletedBookId = "#" + id;
          $(".users-show-items")
            .find(deletedBookId)
            .parent()
            .remove();

          if (status === "1") {
            selectedButton.find("span").text("読んでる本に登録");
          } else if (status === "2") {
            selectedButton.find("span").text("読みたい本に登録");
          }
        })
        .fail(function() {
          alert("エラーが発生しました");
        });
    });
  }
});
