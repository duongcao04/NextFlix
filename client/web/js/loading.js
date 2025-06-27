const setLoadingScreen = () => {
  const loadingScreen = document.getElementById("loadingScreen");
  const mainContent = document.getElementById("mainContent");

  setTimeout(() => {
    // Ẩn loading screen
    loadingScreen.style.opacity = "0";
    setTimeout(() => {
      loadingScreen.style.display = "none";

      // Hiện nội dung chính sau khi loader ẩn
      mainContent.style.display = "block";
    }, 300);
  }, 500); // chờ dữ liệu và UI sẵn sàng
}