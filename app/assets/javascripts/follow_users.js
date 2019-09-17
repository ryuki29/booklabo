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

        $(".follow-btn")
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

        $(".follow-btn")
          .text("フォローする")
          .removeClass("following");
      })
      .fail(function() {
        alert("エラーが発生しました");
      });
  }

  $(".follow-btn").on("click", function() {
    let followed_id = $("#user-id").attr("data-id");

    if ($(this).hasClass("following")) {
      unfollowUser(followed_id);
    } else {
      followUser(followed_id);
    }
  });

  function buildUserHTML(user) {
    let html = `
    <div class="follower-item d-flex mb-4">
      ${user.image}
      <a class="follower-name" href="/users/${user.id}">
        ${user.name}
      </a>
    </div>`;
    return html;
  }

  function fetchFollowers(user_id) {
    let url = `/relationships/${user_id}/followers`;
    $.ajax({
      url: url,
      method: "get",
      dataType: "json"
    })
      .done(function(followers) {
        followers.forEach(user => {
          let html = buildUserHTML(user);
          $("#user-list").append(html);
        });
      })
      .fail(function() {});
  }

  $("#show-followers").on("click", function() {
    $("#user-list").empty();
    let user_id = $("#user-id").attr("data-id");
    fetchFollowers(user_id);
  });

  function fetchFollowing(user_id) {
    let url = `/relationships/${user_id}/following`;
    $.ajax({
      url: url,
      method: "get",
      dataType: "json"
    })
      .done(function(following) {
        following.forEach(user => {
          let html = buildUserHTML(user);
          $("#user-list").append(html);
        });
      })
      .fail(function() {});
  }

  $("#show-following").on("click", function() {
    $("#user-list").empty();
    let user_id = $("#user-id").attr("data-id");
    fetchFollowing(user_id);
  });
});
