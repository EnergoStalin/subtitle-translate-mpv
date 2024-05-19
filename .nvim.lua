local overseer = require('overseer')

overseer.register_template({
	name = 'Debug subtitle-translator',
	builder = function ()
		return {
			name = 'Debug subtitle-translator',
			cmd = {
				'mpv',
				'--fs',
				'--fs-screen=0',
				'--slang=en',
				'--script-opts-append=sub-translator-debug=1',
				'--start=00:00:08',
				'--msg-level=subtitle_translate_mpv=trace,osd=debug',
				'--profile=infinite',
				'test.mkv'
			},
			components = { 'unique', 'default', },
			cwd = vim.fn.getcwd(),
		}
	end,
})
