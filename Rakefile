namespace :package do
  desc "Install a package"
  task :install, [:package,:shit] do |t,args|
    puts args.inspect
    system("sudo pkg install #{args[:package]}")
    if $?.exitstatus != 0
      puts "Failed to install package"
      exit $?.exitstatus
    end
  end

  desc "Build a package in the source repo"
  task :build, :package do |t,args|
    system("cd build/#{args[:package]} && ./build.sh -b")
    if $?.exitstatus != 0
      puts "Failed to build package"
      exit $?.exitstatus
    end
  end

  desc "Build and install a package"
  task :build_and_install, :package do |t,args|
    Rake::Task[:build].execute(args[:package])
    Rake::Task[:install].execute(args[:package])
  end
end

namespace :build do
  PACKAGES = [:samba3, 'ruby-20'.to_sym,:nano]

  PACKAGES.each do |package|
    desc "Build #{package}"
    task package  do
      Rake::Task['package:build'].execute(:package => package)
    end
  end

  desc 'Build all packages'
  task :all => PACKAGES do 

  end

end
