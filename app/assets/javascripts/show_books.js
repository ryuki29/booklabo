$(function() {
  function buildHTML(book) {
    var html = `
    <div class="users-show-items card col-sm-3 border-0">
      <img class="card-img-top" src="${book.image_url}">
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
          status: $(this).data("status")
        },
        dataType: "json"
      })
        .done(function(data) {
          data.forEach(function(book) {
            let html = buildHTML(book);
            $("#user-show-item-list").append(html);
          });
        })
        .fail(function() {
          alert("エラーが発生しました");
        });
    }
  });
});
