return {
  {
    "jpalardy/vim-slime",
    vim.cmd('let g:slime_target = "kitty"'),
    vim.cmd("let g:slime_python_ipython = 1"),
    vim.cmd('let g:slime_default_config= {"window_id": "1", "listen_on": "unix:/tmp/mykitty"}'),
    vim.cmd([[
    function SlimeOverrideConfig()
      let b:slime_config = {}
    
      if !exists("b:slime_config")
        let b:slime_config = {"x_window_pid": "", "window_id": 1}
      end
      let b:slime_config["window_id"] = 1
      if v:shell_error || b:slime_config["window_id"] == $KITTY_WINDOW_ID
        let b:slime_config["window_id"] = input("kitty window_id: ", b:slime_config["window_id"])
      endif
    
      let b:slime_config["x_window_pid"] = trim(slime#common#system("xdotool selectwindow getwindowpid", []))
    
      let b:slime_config["listen_on"] = "unix:/tmp/mykitty-" .. b:slime_config["x_window_pid"]
    endfunction
    ]]),
  },
}
