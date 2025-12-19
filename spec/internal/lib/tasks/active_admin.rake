namespace :active_admin do
  desc 'Build Active Admin Tailwind stylesheets'
  task :build do
    require 'fileutils'

    root = File.expand_path('../../', __dir__)

    # Ensure builds directory exists
    FileUtils.mkdir_p(File.join(root, 'app/assets/builds'))

    # Build Active Admin JavaScript bundle
    system('node', File.join(root, 'esbuild.config.js'), exception: true)

    tailwind_cli = File.join(root, 'bin/tailwindcss')

    # Build with Tailwind CLI
    command = [
      tailwind_cli,
      '-i', File.join(root, 'app/assets/stylesheets/active_admin.tailwind.css'),
      '-o', File.join(root, 'app/assets/builds/active_admin.css'),
      '-m'
    ]

    system(*command, exception: true)

    puts 'Built Active Admin CSS with Tailwind'
  end

  desc 'Watch Active Admin Tailwind stylesheets'
  task :watch do
    root = File.expand_path('../../', __dir__)

    tailwind_cli = File.join(root, 'bin/tailwindcss')

    # Watch for changes
    command = [
      tailwind_cli,
      '--watch',
      '-i', File.join(root, 'app/assets/stylesheets/active_admin.tailwind.css'),
      '-o', File.join(root, 'app/assets/builds/active_admin.css'),
      '-m'
    ]

    system(*command)
  end
end

# Enhance existing rake tasks
if Rake::Task.task_defined?('assets:precompile')
  Rake::Task['assets:precompile'].enhance(['active_admin:build'])
end
if Rake::Task.task_defined?('test:prepare')
  Rake::Task['test:prepare'].enhance(['active_admin:build'])
end
if Rake::Task.task_defined?('spec:prepare')
  Rake::Task['spec:prepare'].enhance(['active_admin:build'])
end
if Rake::Task.task_defined?('db:test:prepare')
  Rake::Task['db:test:prepare'].enhance(['active_admin:build'])
end
