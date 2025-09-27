// Tab switching functionality
document.addEventListener('DOMContentLoaded', function() {
    // Get all navigation links and tab contents
    const navLinks = document.querySelectorAll('.nav-link');
    const tabContents = document.querySelectorAll('.tab-content');

    // Add click event listeners to navigation links
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Get the target tab
            const targetTab = this.getAttribute('data-tab');
            
            // Remove active class from all nav links and tab contents
            navLinks.forEach(navLink => navLink.classList.remove('active'));
            tabContents.forEach(tabContent => tabContent.classList.remove('active'));
            
            // Add active class to clicked nav link and corresponding tab content
            this.classList.add('active');
            document.getElementById(targetTab).classList.add('active');
        });
    });

    // Form submission handlers (placeholder functionality)
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            showNotification('Feature coming soon! Database integration required.', 'info');
        });
    });

    // Button click handlers (placeholder functionality)
    const buttons = document.querySelectorAll('.btn:not(.nav-link)');
    buttons.forEach(button => {
        if (button.textContent.includes('Add') || button.textContent.includes('Schedule')) {
            button.addEventListener('click', function() {
                showNotification('Feature coming soon! Database integration required.', 'info');
            });
        } else if (button.textContent.includes('Edit')) {
            button.addEventListener('click', function() {
                showNotification('Edit functionality coming soon!', 'info');
            });
        } else if (button.textContent.includes('Delete')) {
            button.addEventListener('click', function() {
                if (confirm('Are you sure you want to delete this item?')) {
                    showNotification('Delete functionality coming soon!', 'warning');
                }
            });
        }
    });
});

// Notification system
function showNotification(message, type = 'info') {
    // Remove existing notifications
    const existingNotifications = document.querySelectorAll('.notification');
    existingNotifications.forEach(notification => notification.remove());

    // Create notification element
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.textContent = message;

    // Add styles based on type
    const styles = {
        info: 'background: linear-gradient(45deg, #2196F3, #21CBF3);',
        warning: 'background: linear-gradient(45deg, #FF9800, #FFB74D);',
        success: 'background: linear-gradient(45deg, #4CAF50, #81C784);',
        error: 'background: linear-gradient(45deg, #f44336, #ef5350);'
    };

    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 15px 25px;
        border-radius: 8px;
        color: white;
        font-weight: 600;
        z-index: 1000;
        ${styles[type]}
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        animation: slideIn 0.3s ease;
    `;

    // Add animation keyframes if not already added
    if (!document.querySelector('#notification-styles')) {
        const style = document.createElement('style');
        style.id = 'notification-styles';
        style.textContent = `
            @keyframes slideIn {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
        `;
        document.head.appendChild(style);
    }

    // Add to body
    document.body.appendChild(notification);

    // Auto remove after 3 seconds
    setTimeout(() => {
        notification.style.animation = 'slideIn 0.3s ease reverse';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// Sample data for dynamic content updates (simulating database queries)
const sampleData = {
    tournaments: [
        { id: 1, name: 'FIFA World Cup 2022', year: 2022, host: 'Qatar', matches: 0 },
        { id: 2, name: 'UEFA Euro 2024', year: 2024, host: 'Germany', matches: 2 },
        { id: 3, name: 'Copa America 2024', year: 2024, host: 'USA', matches: 1 }
    ],
    teams: [
        { id: 1, name: 'Argentina', coach: 'Lionel Scaloni', founded: 1893, league: 'CONMEBOL' },
        { id: 2, name: 'Brazil', coach: 'Dorival Junior', founded: 1914, league: 'CONMEBOL' },
        { id: 3, name: 'France', coach: 'Didier Deschamps', founded: 1904, league: 'UEFA' }
    ],
    players: [
        { id: 1, name: 'Lionel Messi', position: 'Forward', team: 'Argentina', goals: 1 },
        { id: 2, name: 'Kylian Mbappe', position: 'Forward', team: 'France', goals: 2 },
        { id: 3, name: 'Jamal Musiala', position: 'Midfielder', team: 'Germany', goals: 2 }
    ],
    matches: [
        { id: 1, team1: 'Argentina', team2: 'Brazil', score1: 1, score2: 0, date: '2024-07-14', venue: 'Hard Rock Stadium' },
        { id: 2, team1: 'France', team2: 'Spain', score1: 2, score2: 1, date: '2024-07-09', venue: 'Allianz Arena' }
    ]
};

// Search functionality (placeholder)
function searchFunction(searchTerm, dataType) {
    console.log(`Searching for "${searchTerm}" in ${dataType}`);
    // This would typically filter the displayed data
    showNotification(`Search feature coming soon! Searched for: ${searchTerm}`, 'info');
}

// Statistics calculations
function updateStatistics() {
    const totalGoals = sampleData.players.reduce((sum, player) => sum + player.goals, 0);
    const totalMatches = sampleData.matches.length;
    const avgGoals = totalMatches > 0 ? (totalGoals / totalMatches).toFixed(2) : 0;
    
    // Update dashboard stats if elements exist
    const statsElements = {
        totalTournaments: document.querySelector('#totalTournaments'),
        totalTeams: document.querySelector('#totalTeams'),
        totalPlayers: document.querySelector('#totalPlayers'),
        totalMatches: document.querySelector('#totalMatches')
    };
    
    // Update values if elements exist
    Object.keys(statsElements).forEach(key => {
        if (statsElements[key]) {
            switch(key) {
                case 'totalTournaments':
                    statsElements[key].textContent = sampleData.tournaments.length;
                    break;
                case 'totalTeams':
                    statsElements[key].textContent = sampleData.teams.length;
                    break;
                case 'totalPlayers':
                    statsElements[key].textContent = sampleData.players.length;
                    break;
                case 'totalMatches':
                    statsElements[key].textContent = sampleData.matches.length;
                    break;
            }
        }
    });
}

// Initialize statistics on page load
document.addEventListener('DOMContentLoaded', function() {
    updateStatistics();
});

// Utility functions for future database integration
const dbUtils = {
    // Placeholder functions for CRUD operations
    create: function(table, data) {
        console.log(`Creating new record in ${table}:`, data);
        showNotification(`${table} record would be created`, 'success');
    },
    
    read: function(table, id = null) {
        console.log(`Reading from ${table}`, id ? `ID: ${id}` : 'All records');
        return sampleData[table] || [];
    },
    
    update: function(table, id, data) {
        console.log(`Updating ${table} record ${id}:`, data);
        showNotification(`${table} record would be updated`, 'success');
    },
    
    delete: function(table, id) {
        console.log(`Deleting from ${table}, ID: ${id}`);
        showNotification(`${table} record would be deleted`, 'warning');
    }
};

// Form validation helpers
const formValidation = {
    validateTournament: function(formData) {
        const errors = [];
        if (!formData.name || formData.name.trim().length < 3) {
            errors.push('Tournament name must be at least 3 characters');
        }
        if (!formData.year || formData.year < 1900 || formData.year > 2030) {
            errors.push('Please enter a valid year between 1900 and 2030');
        }
        if (!formData.hostCountry || formData.hostCountry.trim().length < 2) {
            errors.push('Host country must be at least 2 characters');
        }
        return errors;
    },
    
    validateTeam: function(formData) {
        const errors = [];
        if (!formData.name || formData.name.trim().length < 2) {
            errors.push('Team name must be at least 2 characters');
        }
        if (formData.foundedYear && (formData.foundedYear < 1800 || formData.foundedYear > new Date().getFullYear())) {
            errors.push('Please enter a valid founded year');
        }
        return errors;
    },
    
    validatePlayer: function(formData) {
        const errors = [];
        if (!formData.name || formData.name.trim().length < 2) {
            errors.push('Player name must be at least 2 characters');
        }
        if (!formData.position) {
            errors.push('Please select a position');
        }
        if (!formData.team) {
            errors.push('Please select a team');
        }
        return errors;
    }
};

// Event handlers for specific actions
function handleFormSubmit(formType, formElement) {
    const formData = new FormData(formElement);
    const data = Object.fromEntries(formData.entries());
    
    let errors = [];
    switch(formType) {
        case 'tournament':
            errors = formValidation.validateTournament(data);
            break;
        case 'team':
            errors = formValidation.validateTeam(data);
            break;
        case 'player':
            errors = formValidation.validatePlayer(data);
            break;
    }
    
    if (errors.length > 0) {
        showNotification(errors[0], 'error');
        return false;
    }
    
    dbUtils.create(formType, data);
    formElement.reset();
    return true;
}

// Initialize tooltips and help text (if needed in future)
function initializeHelpers() {
    // Add helpful tooltips or guidance text
    const helpTexts = {
        tournament: 'Create and manage football tournaments',
        team: 'Register teams participating in tournaments',
        player: 'Add players and assign them to teams',
        match: 'Schedule and record match results',
        statistics: 'View comprehensive tournament statistics'
    };
    
    // This could be expanded to show contextual help
    console.log('Help system initialized', helpTexts);
}