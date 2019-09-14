$(document).on("turbolinks:load", function() {
  $("#edit-profile").on("click", function() {
    console.log("OK");
    let image = $(".user-show-avatar").attr("src");
    $(".edit-user-image").attr("src", image);
    $(".custom-file-input").val("");
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
});
