$(document).on("turbolinks:load", function() {
  function followUser(followed_id) {
    $.ajax({
      url: "/relationships",
      method: "post",
      data: {
        followed_id: followed_id
      },
      dataType: "json"
    })
      .done(function() {
        let following_count = Number($("#followed").text());
        following_count = following_count + 1;
        $("#followed").text(following_count);

        $("#follow-btn")
          .text("フォロー中")
          .addClass("following");
      })
      .fail(function() {
        alert("エラーが発生しました");
      });
  }

  function unfollowUser(followed_id) {
    $.ajax({
      url: `/relationships/${followed_id}`,
      method: "delete",
      dataType: "json"
    })
      .done(function() {
        let following_count = Number($("#followed").text());
        following_count = following_count - 1;
        $("#followed").text(following_count);

        $("#follow-btn")
          .text("フォローする")
          .removeClass("following");
      })
      .fail(function() {
        alert("エラーが発生しました");
      });
  }

  $("#follow-btn").on("click", function() {
    let followed_id = $("#user-id").attr("data-id");

    if ($(this).hasClass("following")) {
      unfollowUser(followed_id);
    } else {
      followUser(followed_id);
    }
  });
});
