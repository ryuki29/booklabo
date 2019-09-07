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

    $(".add-book").on("click", function() {
      let title = $(this).data("title");
      let author = $(this).data("author");
      let image = $(this).data("image");
      let uid = $(this).data("uid");

      $("#modal-book-title").text(title);
      $("#modal-book-author").text(author);
      $("#modal-book-img").attr("src", image);

      $("#modal-book-data").attr("data-title", title);
      $("#modal-book-data").attr("data-author", author);
      $("#modal-book-data").attr("data-image", image);
      $("#modal-book-data").attr("data-uid", uid);
    });
  }
});
