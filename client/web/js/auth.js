firebase.auth().onAuthStateChanged((user) => {
  const loginBtn = document.getElementById('loginBtn');
  const logoutBtn = document.getElementById('logoutBtn');
  const userEmail = document.getElementById('userEmail');
  const authContainer = document.getElementById('authContainer');

  if (user) {
    loginBtn.style.display = 'none';
    logoutBtn.style.display = 'none';
    userEmail.style.display = 'none';

    if (!document.getElementById('userAvatarWrapper')) {
      const wrapper = document.createElement('div');
      wrapper.id = 'userAvatarWrapper';
      wrapper.style.position = 'relative';

      // Avatar
      let avatar;
      if (user.photoURL) {
        avatar = document.createElement('img');
        avatar.src = user.photoURL;
      } else {
        const initial = user.email.charAt(0).toUpperCase();
        avatar = document.createElement('div');
        avatar.textContent = initial;
        avatar.style.backgroundColor = '#555';
        avatar.style.color = '#fff';
        avatar.style.display = 'flex';
        avatar.style.alignItems = 'center';
        avatar.style.justifyContent = 'center';
        avatar.style.fontWeight = 'bold';
        avatar.style.fontSize = '14px';
      }

      avatar.id = 'userAvatar';
      avatar.style.width = '32px';
      avatar.style.height = '32px';
      avatar.style.borderRadius = '50%';
      avatar.style.marginLeft = '10px';
      avatar.style.cursor = 'pointer';

      // Dropdown
      const dropdown = document.createElement('div');
      dropdown.id = 'avatarDropdown';
      dropdown.className = 'dropdown-menu'; // <-- dùng class để style
      dropdown.innerHTML = `
        <a href="hoso.html" class="dropdown-item"> Hồ sơ</a>
        <a href="lichsu.html" class="dropdown-item"> Lịch sử xem</a>
        <div id="dropdownLogout" class="dropdown-item logout">🚪 Đăng xuất</div>
      `;

      // Toggle dropdown hiển thị
      avatar.addEventListener('click', (e) => {
        e.stopPropagation();
        dropdown.classList.toggle('show');
      });

      // Click bên ngoài thì ẩn
      document.addEventListener('click', (e) => {
        if (!wrapper.contains(e.target)) {
          dropdown.classList.remove('show');
        }
      });

      // Đăng xuất
      dropdown.querySelector('#dropdownLogout').addEventListener('click', () => {
        firebase.auth().signOut()
          .then(() => window.location.href = 'index.html')
          .catch((error) => alert('Đăng xuất thất bại!'));
      });

      wrapper.appendChild(avatar);
      wrapper.appendChild(dropdown);
      authContainer.appendChild(wrapper);
    }

  } else {
    loginBtn.style.display = 'inline-block';
    logoutBtn.style.display = 'none';
    userEmail.textContent = '';
    userEmail.style.display = 'inline';

    const avatarWrapper = document.getElementById('userAvatarWrapper');
    if (avatarWrapper) avatarWrapper.remove();
  }
});

document.getElementById('loginBtn').addEventListener('click', () => {
  window.location.href = 'login.html';
});
