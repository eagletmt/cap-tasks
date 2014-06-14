worker_processes 2

listen '/tmp/fastladder.sock'
pid 'log/unicorn.pid'

stdout_path 'log/unicorn-out.log'
stderr_path 'log/unicorn-err.log'
