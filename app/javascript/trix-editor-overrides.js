window.addEventListener("trix-file-accept", function(e) {
  const acceptedTypes = ['image/jpeg', 'image/png', 'image/gif'];
  if (!acceptedTypes.includes(e.file.type)) {
    e.preventDefault();
    alert("jpeg, png, gifファイルのみ対応しています。");
  }
});