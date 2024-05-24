local overseer = require('overseer')

overseer.register_template({
	name = 'debug',
	builder = function ()
		return {
			name = 'subtitle-translator',
			cmd = {
				'mpv',
				'--fs',
				'--fs-screen=0',
				'--slang=en',
				'--script-opts-append=sub-translator-debug=1',
				'--start=00:00:01',
				'--msg-level=subtitle_translate_mpv=trace,osd=debug',
				'--profile=infinite',
				'test.mkv'
			},
			components = { 'unique', 'default', },
			cwd = vim.fn.getcwd(),
		}
	end,
})

overseer.register_template({
	name = 'ffmpeg extract subtitles',
	builder = function ()
		return {
			name = 'ffmpeg',
			cmd = {
				'ffmpeg',
				'-i',
				'test.mkv',
				'-y',
				'-map',
				'0:s:0',
				'test.ass',
			},
			components = { 'unique', 'default' },
			cwd = vim.fn.getcwd(),
		}
	end,
})
