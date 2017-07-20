require 'tempfile'
require 'fileutils'
require 'shellwords'
require 'bundler'
Bundler.require
HighLine.color_scheme = HighLine::SampleColorScheme.new

task :default => %w[sanity_checks spec]

desc "Run default set of tasks"
task :spec => %w[spec:all]

desc "Run internal release process, pushing to internal GitHub Enterprise only"
task :release => %w[release:assumptions sanity_checks release:check_working_directory release:bump_version release:test release:lint_podspec release:tag release:push_private]

desc "Publish code and pod to public github.com"
task :publish => %w[publish:push publish:push_pod publish:cocoadocs]

desc "Distribute app, in its current state, to HockeyApp"
task :distribute => %w[distribute:build distribute:hockeyapp]

SEMVER = /\d+\.\d+\.\d+(-[0-9A-Za-z.-]+)?/
PODSPEC = "Braintree.podspec"
BRAINTREE_VERSION_FILE = "BraintreeCore/Braintree-Version.h"
PAYPAL_ONE_TOUCH_VERSION_FILE = "BraintreePayPal/PayPalUtils/Public/PPOTVersion.h"
DEMO_PLIST = "Demo/Supporting Files/Braintree-Demo-Info.plist"
FRAMEWORKS_PLIST = "BraintreeCore/Info.plist"
PUBLIC_REMOTE_NAME = "public"

class << self
  def run cmd
    say(HighLine.color("$ #{cmd}", :debug))
    File.popen(cmd) { |file|
      if block_given?
        result = ''
        result << file.gets until file.eof?
        yield result
      else
        puts file.gets until file.eof?
      end
    }
    $? == 0
  end

  def run! cmd
    run(cmd) or fail("Command failed with non-zero exit status #{$?}:\n$ #{cmd}")
  end

  def current_version
    File.read(PODSPEC)[SEMVER]
  end

  def current_version_with_sha
    %x{git describe}.strip
  end

  def current_branch
    %x{git rev-parse --abbrev-ref HEAD}.strip
  end

  def xcodebuild(scheme, command, configuration, ios_version, options={})
    default_options = {
      :build_settings => {}
    }
    ios_version_specifier = ",OS=#{ios_version}" if !ios_version.nil?
    options = default_options.merge(options)
    build_settings = options[:build_settings].map{|k,v| "#{k}='#{v}'"}.join(" ")
    return "set -o pipefail && xcodebuild -workspace 'Braintree.xcworkspace' -sdk 'iphonesimulator' -configuration '#{configuration}' -scheme '#{scheme}' -destination 'name=iPhone 6,platform=iOS Simulator#{ios_version_specifier}' #{build_settings} #{command} | xcpretty -c -r junit"
  end

end

namespace :spec do
  def run_test_scheme! scheme, ios_version = nil
    run! xcodebuild(scheme, 'test', 'Release', ios_version)
  end

  desc 'Run unit tests'
  task :unit, [:ios_version] do |t, args|
    if args[:ios_version]
      run_test_scheme! 'UnitTests', args[:ios_version]
    else
      run_test_scheme! 'UnitTests'
    end
  end

  desc 'Run UI tests'
  task :ui do
    run_test_scheme! 'UITests'
  end

  namespace :api do
    def with_https_server &block
      begin
        pid = Process.spawn('ruby ./IntegrationTests/Braintree-API-Integration-Specs/SSL/https_server.rb')
        puts "Started server (#{pid})"
        yield
        puts "Killing server (#{pid})"
      ensure
        Process.kill("INT", pid)
      end
    end

    desc 'Run integration tests'
    task :integration do
      with_https_server do
        run! xcodebuild('IntegrationTests', 'test', 'Release', nil, :build_settings => {'GCC_PREPROCESSOR_DEFINITIONS' => '$GCC_PREPROCESSOR_DEFINITIONS RUN_SSL_PINNING_SPECS=1'})
      end
    end
  end

  desc 'Run all spec schemes'
  task :all => %w[spec:unit spec:api:integration spec:ui]
end

namespace :demo do
  desc 'Verify that the demo app builds successfully'
  task :build do
    run! xcodebuild('Demo', 'build', 'Release', nil)
  end
end

desc 'Run Carthage update'
namespace :carthage do
  def generate_cartfile
    File.write("./Cartfile", "git \"file://#{Dir.pwd}\" \"#{current_branch}\"")
  end

  task :generate do
    generate_cartfile
  end

  task :clean do
    run! 'rm -rf Carthage && rm Cartfile && rm Cartfile.resolved && rm -rf ~/Library/Developers/Xcode/DerivedData'
  end

  task :test do
    generate_cartfile
    run! "carthage update"
    run! "xcodebuild -project 'Demo/CarthageTest/CarthageTest.xcodeproj' -scheme 'CarthageTest' clean build"
  end
end

desc 'Run all sanity checks'
task :sanity_checks => %w[sanity_checks:pending_specs sanity_checks:build_demo sanity_checks:carthage_test]

namespace :sanity_checks do
  desc 'Check for pending tests'
  task :pending_specs do
    # ack returns 1 if no match is found, which is our success case
    run! "which -s ack && ! ack 'fit\\(|fdescribe\\(' Specs" or fail "Please do not commit pending specs."
  end

  desc 'Verify that all demo apps Build successfully'
  task :build_demo => 'demo:build'

  desc 'Verify that Carthage builds successfully'
  task :carthage_test => %w[carthage:test carthage:clean]
end



def apple_doc_command
  %W[/usr/local/bin/appledoc
      -o appledocs
      --project-name Braintree
      --project-version '#{current_version_with_sha}'
      --project-company Braintree
      --docset-bundle-id '%COMPANYID'
      --docset-bundle-name Braintree
      --docset-desc 'Braintree iOS SDK (%VERSION)'
      --index-desc README.md
      --include LICENSE
      --include CHANGELOG.md
      --print-information-block-titles
      --company-id com.braintreepayments
      --prefix-merged-sections
      --no-merge-categories
      --warn-missing-company-id
      --warn-undocumented-object
      --warn-undocumented-member
      --warn-empty-description
      --warn-unknown-directive
      --warn-invalid-crossref
      --warn-missing-arg
      --no-repeat-first-par
  ].join(' ')
end

def apple_doc_files
  %x{find Braintree -name "*.h"}.split("\n").reject { |name| name =~ /mSDK/}.map { |name| name.gsub(' ', '\\ ')}.join(' ')
end

desc "Generate documentation via appledoc"
task :docs => 'docs:generate'

namespace :appledoc do
  task :check do
    unless File.exists?('/usr/local/bin/appledoc')
      puts "appledoc not found at /usr/local/bin/appledoc: Install via homebrew and try again: `brew install --HEAD appledoc`"
      exit 1
    end
  end
end

namespace :docs do
  desc "Generate apple docs as html"
  task :generate => 'appledoc:check' do
    command = apple_doc_command << " --no-create-docset --keep-intermediate-files --create-html #{apple_doc_files}"
    run(command)
    puts "Generated HTML documentationa at appledocs/html"
  end

  desc "Check that documentation can be built from the source code via appledoc successfully."
  task :check => 'appledoc:check' do
    command = apple_doc_command << " --no-create-html --verbose 5 #{apple_doc_files}"
    exitstatus = run(command)
    if exitstatus == 0
      puts "appledoc generation completed successfully!"
    elsif exitstatus == 1
      puts "appledoc generation produced warnings"
    elsif exitstatus == 2
      puts "! appledoc generation encountered an error"
      exit(exitstatus)
    else
      puts "!! appledoc generation failed with a fatal error"
    end
    exit(exitstatus)
  end

  desc "Generate & install a docset into Xcode from the current sources"
  task :install => 'appledoc:check' do
    command = apple_doc_command << " --install-docset #{apple_doc_files}"
    run(command)
  end
end


namespace :release do
  desc "Print out pre-release checklist"
  task :assumptions do
    say "Release Assumptions"
    say "* [ ] You have pulled and reconciled origin (internal GitHub Enterprise) vs public (github.com)."
    say "* [ ] You are on the branch and commit you want to release."
    say "* [ ] You have already merged hotfixes and pulled changes."
    say "* [ ] You have already reviewed the diff between the current release and the last tag, noting breaking changes in the semver and CHANGELOG."
    say "* [ ] Tests are passing, manual verifications complete."
    say "* [ ] iOS Simulator has hardware keyboard disabled"
    say "* [ ] Email is composed and ready to send to braintree-sdk-announce@googlegroups.com"

    abort(1) unless ask "Ready to release? "
  end

  desc "Check that working directory is clean"
  task :check_working_directory do
    run! "echo 'Checking for uncommitted changes' && git diff --exit-code"
  end

  desc "Bump version in Podspec"
  task :bump_version do
    say "Current version in Podspec: #{current_version}"
    n = 10
    say "Previous #{n} versions in Git:"
    run "git tag -l | tail -n #{n}"
    version = ask("What version are you releasing?") { |q| q.validate = /\A#{SEMVER}\Z/ }

    podspec = File.read(PODSPEC)
    podspec.gsub!(/(s\.version\s*=\s*)"#{SEMVER}"/, "\\1\"#{version}\"")
    File.open(PODSPEC, "w") { |f| f.puts podspec }

    version_header = File.read(BRAINTREE_VERSION_FILE)
    version_header.gsub!(SEMVER, version)
    File.open(BRAINTREE_VERSION_FILE, "w") { |f| f.puts version_header }

    version_header = File.read(PAYPAL_ONE_TOUCH_VERSION_FILE)
    version_header.gsub!(SEMVER, version)
    File.open(PAYPAL_ONE_TOUCH_VERSION_FILE, "w") { |f| f.puts version_header }

    [DEMO_PLIST, FRAMEWORKS_PLIST].each do |plist|
      run! "plutil -replace CFBundleVersion -string #{current_version} -- '#{plist}'"
      run! "plutil -replace CFBundleShortVersionString -string #{current_version} -- '#{plist}'"
    end
    run "git commit -m 'Bump pod version to #{version}' -- #{PODSPEC} Podfile.lock '#{DEMO_PLIST}' '#{FRAMEWORKS_PLIST}' #{BRAINTREE_VERSION_FILE} #{PAYPAL_ONE_TOUCH_VERSION_FILE}"
  end

  desc  "Test."
  task :test => 'spec:all'

  desc  "Lint podspec."
  task :lint_podspec do
    run! "pod lib lint Braintree.podspec --allow-warnings"
  end

  desc  "Tag."
  task :tag do
    run! "git tag #{current_version} -a -m 'Release #{current_version}'"
  end

  desc  "Push tag to ghe."
  task :push_private do
    run! "git push origin HEAD #{current_version}"
  end

end

namespace :publish do

  desc  "Push code and tag to github.com"
  task :push do
    run! "git push #{PUBLIC_REMOTE_NAME} HEAD #{current_version}"
  end

  desc  "Pod push."
  task :push_pod do
    run! "pod trunk push --allow-warnings Braintree.podspec"
  end

  desc "Force CocoaDocs reparse"
  task :cocoadocs do
    run! "curl --silent --show-error http://api.cocoadocs.org:4567/redeploy/Braintree/latest"
  end

end

namespace :distribute do
  task :build do
    destination = File.expand_path("~/Desktop/Braintree-Demo-#{current_version_with_sha}")
    run! "ipa build --scheme Demo --destination '#{destination}' --embed EverybodyVenmo.mobileprovision --identity 'iPhone Distribution: Venmo Inc.'"
    say "Archived Demo (#{current_version}) to: #{destination}"
  end

  task :hockeyapp do
    destination = File.expand_path("~/Desktop/Braintree-Demo-#{current_version_with_sha}")
    changes = File.read("CHANGELOG.md")[/(## #{current_version}.*?)^## /m, 1].strip
    run! "ipa distribute:hockeyapp --token '#{File.read(".hockeyapp").strip}' --identifier '7134982f3df6419a0eb52b16e7d6d175' --file '#{destination}/Braintree-Demo.ipa' --dsym '#{destination}/Braintree-Demo.app.dSYM.zip' --markdown --notes #{Shellwords.shellescape("#{changes}\n\n#{current_version_with_sha}")}"
    say "Uploaded Demo (#{current_version_with_sha}) to HockeyApp!"
  end
end

desc "Generate code for pinned certificates. (Copies *.crt -> BTAPIPinnedCertificates.{h,m})"
task :generate_pinned_certificates_code do
  run! "cd #{File.join(File.dirname(__FILE__), "Braintree/API/Networking/Certificates")} && ./codify_certificates.sh"
end

namespace :gen do
  task :strings do
    ["Drop-In", "UI"].each do |subspec|
      run! "genstrings -o Braintree/#{subspec}/Localization/en.lproj Braintree/#{subspec}/**/*.m && " +
           "iconv -f utf-16 -t utf-8 Braintree/#{subspec}/Localization/en.lproj/Localizable.strings > Braintree/#{subspec}/Localization/en.lproj/#{subspec}.strings && " +
           "rm -f Braintree/#{subspec}/Localization/en.lproj/Localizable.strings"
    end
  end
end

