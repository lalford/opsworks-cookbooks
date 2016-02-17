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

    execute "run #{full_cmd}" do
        command "#{script_path}/#{full_cmd}"
    end
end
