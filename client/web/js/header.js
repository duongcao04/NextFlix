// header.js

let isScrolling = false;

function handleScroll() {
  if (!isScrolling) {
    window.requestAnimationFrame(() => {
      const header = document.querySelector('.header');
      if (window.scrollY > 50) {
        header.classList.add('scrolled');
      } else {
        header.classList.remove('scrolled');
      }
      isScrolling = false;
    });
    isScrolling = true;
  }
}

window.addEventListener('scroll', handleScroll, { passive: true });

// Đảm bảo chạy 1 lần để khởi tạo đúng trạng thái nếu load giữa trang
document.addEventListener('DOMContentLoaded', handleScroll);
