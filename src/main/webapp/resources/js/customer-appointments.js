// Customer Appointments JavaScript

document.addEventListener('DOMContentLoaded', function() {
    initializeApp();
});

function initializeApp() {
    // Initialize rating system
    initializeRatingSystem();
    
    // Initialize modal functionality
    initializeModal();
    
    // Initialize form validation
    initializeFormValidation();
}

// Rating System
function initializeRatingSystem() {
    const ratingInputs = document.querySelectorAll('input[name="rating"]');
    const ratingText = document.getElementById('ratingText');
    
    if (ratingInputs.length > 0 && ratingText) {
        ratingInputs.forEach(input => {
            input.addEventListener('change', function() {
                updateRatingText(this.value);
            });
        });
    }
}

function updateRatingText(rating) {
    const ratingText = document.getElementById('ratingText');
    if (ratingText) {
        const ratingDescriptions = {
            1: 'Rất không hài lòng',
            2: 'Không hài lòng',
            3: 'Bình thường',
            4: 'Hài lòng',
            5: 'Rất hài lòng'
        };
        
        ratingText.textContent = ratingDescriptions[rating] || 'Chọn số sao';
        ratingText.style.color = rating >= 4 ? '#28a745' : rating >= 3 ? '#ffc107' : '#dc3545';
    }
}

// Modal Functionality
function initializeModal() {
    const modal = document.getElementById('cancelModal');
    const closeBtn = document.querySelector('.close');
    const cancelForm = document.getElementById('cancelForm');
    
    if (modal && closeBtn) {
        closeBtn.addEventListener('click', closeCancelModal);
        
        // Close modal when clicking outside
        window.addEventListener('click', function(event) {
            if (event.target === modal) {
                closeCancelModal();
            }
        });
    }
    
    if (cancelForm) {
        cancelForm.addEventListener('submit', handleCancelSubmit);
    }
}

function showCancelModal(appointmentId) {
    const modal = document.getElementById('cancelModal');
    const form = document.getElementById('cancelForm');
    
    if (modal && form) {
        // Set the form action to the correct cancel endpoint
        form.action = `/customer/appointments/${appointmentId}/cancel`;
        
        // Clear previous form data
        form.reset();
        
        // Show modal
        modal.style.display = 'block';
        
        // Focus on the first input
        const cancelReason = document.getElementById('cancelReason');
        if (cancelReason) {
            cancelReason.focus();
        }
    }
}

function closeCancelModal() {
    const modal = document.getElementById('cancelModal');
    if (modal) {
        modal.style.display = 'none';
    }
}

function handleCancelSubmit(event) {
    const cancelReason = document.getElementById('cancelReason');
    
    if (!cancelReason || cancelReason.value.trim().length < 5) {
        event.preventDefault();
        alert('Vui lòng nhập lý do hủy lịch (ít nhất 5 ký tự)');
        return false;
    }
    
    // Show confirmation
    if (!confirm('Bạn có chắc chắn muốn hủy lịch hẹn này?')) {
        event.preventDefault();
        return false;
    }
    
    return true;
}

// Form Validation
function initializeFormValidation() {
    const reviewForm = document.querySelector('.review-form');
    
    if (reviewForm) {
        reviewForm.addEventListener('submit', validateReviewForm);
    }
}

function validateReviewForm(event) {
    const rating = document.querySelector('input[name="rating"]:checked');
    const comment = document.getElementById('comment');
    
    if (!rating) {
        event.preventDefault();
        alert('Vui lòng chọn số sao đánh giá');
        return false;
    }
    
    if (comment && comment.value.trim().length > 0 && comment.value.trim().length < 10) {
        event.preventDefault();
        alert('Nhận xét phải có ít nhất 10 ký tự');
        return false;
    }
    
    return true;
}

// Utility Functions
function formatDateTime(dateString) {
    if (!dateString) return '';
    
    const date = new Date(dateString);
    return date.toLocaleDateString('vi-VN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
    });
}

function showAlert(message, type = 'info') {
    // Create alert element
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type}`;
    alertDiv.innerHTML = `
        <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : 'info-circle'}"></i>
        ${message}
    `;
    
    // Insert at the top of main content
    const main = document.querySelector('main');
    if (main) {
        main.insertBefore(alertDiv, main.firstChild);
        
        // Auto remove after 5 seconds
        setTimeout(() => {
            if (alertDiv.parentNode) {
                alertDiv.parentNode.removeChild(alertDiv);
            }
        }, 5000);
    }
}

// Keyboard Navigation
document.addEventListener('keydown', function(event) {
    // ESC key to close modal
    if (event.key === 'Escape') {
        const modal = document.getElementById('cancelModal');
        if (modal && modal.style.display === 'block') {
            closeCancelModal();
        }
    }
    
    // Enter key in modal to submit form
    if (event.key === 'Enter' && event.ctrlKey) {
        const modal = document.getElementById('cancelModal');
        if (modal && modal.style.display === 'block') {
            const form = document.getElementById('cancelForm');
            if (form) {
                form.submit();
            }
        }
    }
});

// Smooth scrolling for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Auto-hide alerts after page load
window.addEventListener('load', function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            if (alert.parentNode) {
                alert.style.opacity = '0';
                setTimeout(() => {
                    if (alert.parentNode) {
                        alert.parentNode.removeChild(alert);
                    }
                }, 300);
            }
        }, 5000);
    });
});

// Enhanced form handling
function enhanceFormHandling() {
    const forms = document.querySelectorAll('form');
    
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            const submitBtn = form.querySelector('button[type="submit"]');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
            }
        });
    });
}

// Initialize enhanced form handling
document.addEventListener('DOMContentLoaded', enhanceFormHandling);

// Responsive navigation
function initializeResponsiveNav() {
    const nav = document.querySelector('.nav');
    const navToggle = document.createElement('button');
    navToggle.className = 'nav-toggle';
    navToggle.innerHTML = '<i class="fas fa-bars"></i>';
    
    if (nav && window.innerWidth <= 768) {
        nav.parentNode.insertBefore(navToggle, nav);
        
        navToggle.addEventListener('click', function() {
            nav.classList.toggle('nav-open');
        });
    }
}

// Initialize responsive navigation
window.addEventListener('resize', initializeResponsiveNav);
document.addEventListener('DOMContentLoaded', initializeResponsiveNav);
