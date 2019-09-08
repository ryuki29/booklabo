$(document).on("turbolinks:load", function() {
  if ($(".pagination").length) {
    let page = $("#pagination-nav").data("page");
    let total = $("#pagination-nav").data("total");

    $(".page-link-num").each(function() {
      if ($(this).data("page") === Number(page)) {
        $(this).addClass("bg-primary text-white");
      }
    });

    if (page === 0) {
      $(".paginate-prev").css("visibility", "hidden");
    }

    if (page + 1 >= total / 20) {
      $(".paginate-next").css("visibility", "hidden");
    }
  }

  if ($(".search-main").length) {
    $(".add-book-cover").hover(
      function() {
        $(this)
          .find(".add-book")
          .css("visibility", "visible");
      },
      function() {
        $(this)
          .find(".add-book")
          .css("visibility", "hidden");
      }
    );
  }

  $(".add-book").on("click", function() {
    let title = $(this).data("title");
    let authors = $(this).data("authors");
    let image = $(this).data("image");
    let uid = $(this).data("uid");

    $("#modal-book-title").text(title);
    $("#modal-book-author").text(authors);
    $("#modal-book-img").attr("src", image);

    $("#readBook").attr("data-title", title);
    $("#readBook").attr("data-authors", authors);
    $("#readBook").attr("data-image", image);
    $("#readBook").attr("data-uid", uid);

    $("#post-review-img").attr("src", image);
    $("#readBookTitle").attr("value", title);
    $("#readBookAuthors").attr("value", authors);
    $("#readBookImage").attr("value", image);
    $("#readBookUid").attr("value", uid);
  });

  $(".fa-star").hover(
    function() {
      $(this).addClass("star-hover");
      $(this)
        .prevAll()
        .addClass("star-hover");
    },
    function() {
      $(this).removeClass("star-hover");
      $(this)
        .prevAll()
        .removeClass("star-hover");
    }
  );

  $(".fa-star").on("click", function() {
    $(".fa-star").removeClass("star-active");
    $(this).addClass("star-active");
    $(this)
      .prevAll()
      .addClass("star-active");
    let rating = $(this).data("rating");
    $("#book-rating").attr("value", rating);
  });

  $("#rating-reset").on("click", function() {
    $("#book-rating").attr("value", 0);
    $(".fa-star").removeClass("star-active");
  });

  $("#date-check").on("click", function() {
    if ($(this).prop("checked") === true) {
      $("#date-input, #calender")
        .attr("disabled", true)
        .addClass("form-disabled");
    } else {
      $("#date-input, #calender")
        .attr("disabled", false)
        .removeClass("form-disabled");
    }
  });

  $("#review-text").on("keyup", function() {
    let wordLength = $(this).val().length;
    $("#word-count").text(wordLength);

    if (wordLength > 255) {
      $("#word-count").css("color", "#d65656");
      $("#review-submit").attr("disabled", true);
    } else {
      $("#word-count").css("color", "#1ea1f1");
      $("#review-submit").removeAttr("disabled");
    }
  });

  $("#review-submit").hover(
    function() {
      $(this).css("opacity", 0.8);
    },
    function() {
      $(this).css("opacity", 1);
    }
  );

  $("#datetimepicker").datetimepicker({
    format: "L",
    format: "YYYY/MM/DD",
    defaultDate: moment(new Date(), "YYYY/MM/DD")
  });
});
