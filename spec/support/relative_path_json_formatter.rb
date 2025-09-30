# Custom SimpleCov JSON formatter that generates relative paths
# This ensures coverage reports work across different environments (local, CI, Docker)
require 'simplecov'
require 'simplecov_json_formatter'
require 'pathname'
require 'json'

class RelativePathJSONFormatter < SimpleCov::Formatter::JSONFormatter
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def format(result)
    # Create the data structure following SimpleCov JSON formatter format
    data = {
      'meta' => {
        'simplecov_version' => SimpleCov::VERSION
      },
      'coverage' => {}
    }

    # Get the project root
    project_root = Pathname.new(SimpleCov.root)

    # Process each file in the result
    result.files.each do |source_file|
      # Make path relative to project root
      absolute_path = Pathname.new(source_file.filename)
      relative_path = absolute_path.relative_path_from(project_root).to_s

      # Add the coverage data
      data['coverage'][relative_path] = source_file.coverage_data['lines']
    end

    # Add coverage summary
    if result.groups.any?
      data['groups'] = result.groups.transform_values do |files|
        {
          'lines' => {
            'covered' => files.covered_lines,
            'total' => files.lines_of_code
          }
        }
      end
    end

    # Save the file
    output_filepath = File.join(SimpleCov.coverage_path, 'coverage.json')
    File.open(output_filepath, 'w') do |f|
      f.puts JSON.pretty_generate(data)
    end

    JSON.generate(data)
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
