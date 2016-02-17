script_path = '/usr/local/bin'

cookbook_file "#{script_path}/spin_and_win.py" do
    source "spin_and_win.py"
    mode 0755
end

cookbook_file "#{script_path}/spin_and_lose.py" do
    source "spin_and_lose.py"
    mode 0755
end

node[:ebs][:targets].each do |target|
    full_cmd = target[:cmd]
    unless target[:args].nil? or target[:args].empty?
        full_cmd = "#{full_cmd} #{target[:args]}"
    end

    ruby_block "run #{full_cmd}" do
        block do
            Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
            result = shell_out(full_cmd)
            status = result.status
            stdout = result.stdout
            stderr = result.stderr

            if status.success?
                Chef::Log.info("----- begin stdout -----")
                stdout.split("\n").each { |line| Chef::Log.info(line) }
                Chef::Log.info("----- end stdout -----")
            else
                Chef::Log.error("----- begin stdout -----")
                stdout.split("\n").each { |line| Chef::Log.error(line) }
                Chef::Log.error("----- end stdout -----")
                Chef::Log.error("----- begin stderr -----")
                stderr.split("\n").each { |line| Chef::Log.error(line) }
                Chef::Log.error("----- end stderr -----")
                Chef::Application.fatal!("failed executing resource [#{full_cmd}], exit code #{status.exitstatus}", status.exitstatus)
            end
        end
    end

    #execute "run #{full_cmd}" do
    #    command "#{script_path}/#{full_cmd}"
    #end
end
