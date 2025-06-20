document.addEventListener('DOMContentLoaded', () => {
  const db = firebase.database();

  function createMovieCard(movie) {
    return `
      <a href="xemphimchitiet.html?id=${movie.id}" class="movie-card">
        <div class="movie-poster" style="background-image: url('${movie.images?.posters || ''}'); background-size: cover;">
          <div class="play-overlay">▶</div>
        </div>
        <div class="movie-info">
          <div class="movie-title">${movie.title}</div>
          <div class="movie-meta">
            <span>${movie.year || 'N/A'} • ${movie.type === 2 ? 'Phim bộ' : 'Phim lẻ'}</span>
            <span class="quality-badge">${movie.rating || 'HD'}</span>
          </div>
        </div>
      </a>
    `;
  }

  function renderMoviesByGenres(genres, movies) {
    const container = document.getElementById('genreSections');
    container.innerHTML = '';

    genres.forEach(genre => {
      const matchedMovies = movies.filter(movie => movie.genres?.includes(genre.id)).slice(0, 8);
      if (matchedMovies.length === 0) return;

      const section = document.createElement('section');
      section.className = 'section';
      section.innerHTML = `
        <h2 class="section-title">${genre.icon || ''} ${genre.name}</h2>
        <div class="movie-grid">
          ${matchedMovies.map(createMovieCard).join('')}
        </div>
      `;

      container.appendChild(section);
    });
  }

  function renderTopicCards(topics) {
    const container = document.getElementById('topicContainer');
    container.innerHTML = topics.map(topic => `
      <div class="topic-card" style="background: ${topic.color};" onclick="filterByTopic('${topic.id}')">
        <h3>${topic.name}</h3>
        <a href="#">Xem chủ đề &rarr;</a>
      </div>
    `).join('');
  }

  function loadBannersFromFeatured() {
    Promise.all([
      db.ref('movies').once('value'),
      db.ref('featured_movies').once('value')
    ]).then(([movieSnap, featuredSnap]) => {
      const moviesData = movieSnap.val() || {};
      const featuredData = featuredSnap.val() || [];

      const movieMap = Object.fromEntries(Object.entries(moviesData).map(([id, m]) => [m.id || id, m]));
      const featured = Object.values(featuredData).map(f => movieMap[f.movie]).filter(m => m?.images?.horizontal_posters || m?.images?.backdrops);

      const bannerWrapper = document.getElementById('bannerWrapper');
      bannerWrapper.innerHTML = featured.slice(0, 5).map(movie => `
        <a href="xemphimchitiet.html?id=${movie.id}" class="swiper-slide" style="
          background-image: url('${movie.images?.horizontal_posters || movie.images?.backdrops || ''}');
          background-size: cover;
          background-position: center;
          min-height: 500px;
          display: flex;
          align-items: center;
          justify-content: flex-start;
          padding-left: 2rem;
          border-radius: 12px;
          text-decoration: none;
        ">
        </a>
      `).join('');

      new Swiper(".mySwiper", {
        pagination: { el: ".swiper-pagination" },
        loop: true,
        autoplay: {
          delay: 3000,
          disableOnInteraction: false
        },
        effect: 'fade'
      });
    });
  }

  db.ref('movies').once('value').then(movieSnap => {
    const allMovies = Object.values(movieSnap.val() || {});
    db.ref('genres').once('value').then(genreSnap => {
      const genres = Object.values(genreSnap.val() || {});
      renderMoviesByGenres(genres, allMovies);
    });
  });

  db.ref('topics').once('value').then(snapshot => {
    const topics = Object.values(snapshot.val() || {});
    renderTopicCards(topics);
  });

  document.querySelector('.search-box').addEventListener('keypress', function (e) {
    if (e.key === 'Enter') {
      const query = this.value.trim();
      if (query) {
        window.location.href = `timkiem.html?query=${encodeURIComponent(query)}`;
      }
    }
  });

  window.addEventListener('scroll', function () {
    const header = document.querySelector('.header');
    header.style.background = window.scrollY > 100 ? 'rgba(0, 0, 0, 0.95)' : 'rgba(0, 0, 0, 0.9)';
  });
});
