// Navbar scroll shadow
window.addEventListener('scroll', function () {
    const navbar = document.querySelector('.cd-navbar');
    if (!navbar) return;
    navbar.style.boxShadow = window.scrollY > 10
        ? '0 4px 20px rgba(0,0,0,0.25)'
        : 'none';
});