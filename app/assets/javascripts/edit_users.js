$(document).on("turbolinks:load", function() {
  $("#edit-profile").on("click", function() {
    console.log("OK");
    let image = $(".user-show-avatar").attr("src");
    $(".edit-user-image").attr("src", image);
    $(".custom-file-input").val("");

    $("#user-name-count").text($("#edit-user-name").val().length);
    $("#user-description-count").text($("#edit-user-description").val().length);
    $("#user-url-count").text($("#edit-user-url").val().length);
  });

  $(".custom-file-input").on("change", function(e) {
    let file = e.target.files[0];
    let reader = new FileReader();

    if (file.type.indexOf("image") < 0) {
      alert("画像ファイルを選択してください");
      return false;
    }

    reader.onload = (function(file) {
      return function(e) {
        $(".edit-user-image").attr("src", e.target.result);
      };
    })(file);
    reader.readAsDataURL(file);
  });

  $("#edit-user-name").on("keyup", function() {
    let nameLength = $(this).val().length;
    $("#user-name-count").text(nameLength);
  });

  $("#edit-user-description").on("keyup", function() {
    let descriptionLength = $(this).val().length;
    $("#user-description-count").text(descriptionLength);
  });

  $("#edit-user-url").on("keyup", function() {
    let urlLength = $(this).val().length;
    $("#user-url-count").text(urlLength);
  });
});
