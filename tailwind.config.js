module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
  ],
  plugins: [
    require("daisyui"),
  ],
  daisyui: {
    themes: [
      'lemonade',
      'coffee',
      {
        'lemonade': {
          'primary': '#ff6b6b',
          'primary-focus': '#ff3333',
          'primary-content': '#ffffff',
          'secondary': '#fdd157',
          'secondary-focus': '#fdaa2a',
          'secondary-content': '#ffffff',
          'accent': '#37cdbe',
          'accent-focus': '#2aa79b',
          'accent-content': '#ffffff',
          'neutral': '#1b262c',
          'neutral-focus': '#0a1014',
          'neutral-content': '#ffffff',
          'base-100': '#ffffff',
          'base-200': '#f9fafb',
          'base-300': '#d1d5db',
          'base-content': '#1f2937',
          'info': '#2094f3',
          'success': '#009485',
          'warning': '#ff9900',
          'error': '#ff5724',
        },
        'coffee': {
          'primary': '#a2627a',
          'primary-focus': '#7b4559',
          'primary-content': '#ffffff',
          'secondary': '#9da1a5',
          'secondary-focus': '#7b7d80',
          'secondary-content': '#ffffff',
          'accent': '#262b40',
          'accent-focus': '#1a1f2c',
          'accent-content': '#ffffff',
          'neutral': '#2e353f',
          'neutral-focus': '#23292f',
          'neutral-content': '#ffffff',
          'base-100': '#ffffff',
          'base-200': '#f9fafb',
          'base-300': '#d1d5db',
          'base-content': '#1f2937',
          'info': '#2094f3',
          'success': '#009485',
          'warning': '#ff9900',
          'error': '#ff5724',
        }
      }
    ]
  },
  darkMode: 'media',
}
