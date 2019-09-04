$(document).on("turbolinks:load", function() {
  if ($(".pagination").length) {
    let page = $("#pagination-nav").data("page");
    let total = $("#pagination-nav").data("total");

    $(".page-link-num").each(function() {
      if ($(this).data("page") === Number(page)) {
        $(this).addClass("bg-primary text-white");
        console.log($(this));
      }
    });

    if (page === 0) {
      $(".paginate-prev").css("visibility", "hidden");
    }

    if (page + 1 >= total / 20) {
      $(".paginate-next").css("visibility", "hidden");
    }
  }
});
