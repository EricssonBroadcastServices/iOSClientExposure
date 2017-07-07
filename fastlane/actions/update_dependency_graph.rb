module Fastlane
    module Actions
        module SharedValues
            ##COMMIT_CARTHAGE_DEPENDENCIES_CUSTOM_VALUE = :COMMIT_CARTHAGE_DEPENDENCIES_CUSTOM_VALUE
        end
        
        class UpdateDependencyGraphAction < Action
            def self.run(params)
                #require 'xcodeproj'
                #require 'pathname'
                #require 'set'
                #require 'shellwords'
                
                # find the repo root path
                repo_path = Actions.sh('git rev-parse --show-toplevel').strip
                repo_pathname = Pathname.new(repo_path)
                
                # create our list of files that we expect to have changed, they should all be relative to the project root, which should be equal to the git workdir root
                # 1. Cartfile.resolved
                cartfile = "Cartfile.resolved"
                
                # 2. Carthage/Checkouts/** (ie any change in submodules is ok)
                submodule_directory = "Carthage/Checkouts/"
                
                
                UI.message("Valid Files: #{cartfile} and #{submodule_directory}**")
                
                # get the list of files that have actually changed in our git workdir
                git_dirty_files = Actions.sh('git diff --name-only HEAD').split("\n") + Actions.sh('git ls-files --other --exclude-standard').split("\n")
                
                UI.message("Changed Files: #{git_dirty_files}")
                
                valid_changed_files = []
                valid_changed_files = git_dirty_files.select { |i| i.start_with?(submodule_directory) }
                if (git_dirty_files.include? cartfile)
                    valid_changed_files << cartfile
                end
                
                UI.message("Found Valid Files: #{valid_changed_files}")
                
                if (valid_changed_files == git_dirty_files)
                    UI.message("Valid files MATCH dirty files")
                else
                    UI.error("MISMATCH between valid files and dirty files")
                end
                
                # fastlane will take care of reading in the parameter and fetching the environment variable:
                #UI.message "Parameter API Token: #{params[:api_token]}"
                
                # sh "shellcommand ./path"
                
                # Actions.lane_context[SharedValues::COMMIT_CARTHAGE_DEPENDENCIES_CUSTOM_VALUE] = "my_val"
            end
        
            #####################################################
            # @!group Documentation
            #####################################################
            
            def self.description
                "A short description with <= 80 characters of what this action does"
            end
        
            def self.details
                # Optional:
                # this is your chance to provide a more detailed description of this action
                "You can use this action to do cool things..."
            end

            def self.available_options
                [
#           # Define all options your action supports.
#                                   end),
# FastlaneCore::ConfigItem.new(key: :development,
#                                        env_name: "FL_COMMIT_CARTHAGE_DEPENDENCIES_DEVELOPMENT",
#                                        description: "Create a development certificate instead of a distribution one",
#                                        is_string: false, # true: verifies the input is a string, false: every kind of value
#                                        default_value: false) # the default value if the user didn't provide one
                ]
            end

            def self.output
#               # Define the shared values you are going to provide
#               # Example
#               [
#                   ['COMMIT_CARTHAGE_DEPENDENCIES_CUSTOM_VALUE', 'A description of what this value contains']
#               ]
            end

            def self.return_value
                # If you method provides a return value, you can describe here what it does
            end

            def self.authors
                # So no one will ever forget your contribution to fastlane :) You are awesome btw!
                ["Your GitHub/Twitter Name"]
            end

            def self.is_supported?(platform)
            # you can do things like
            #
            #  true
            #
            #  platform == :ios
            #
            #  [:ios, :mac].include?(platform)
            #

                platform == :ios
            end
        end
    end
end
