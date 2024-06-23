local mp = require 'mp'
local logger = require 'logger' ('benchmark')

local values = {
	'Our online English classes feature lots of useful learning materials and activities to help you develop your reading skills with confidence in a safe and inclusive learning environment.',
	'Practise reading with your classmates in live group classes, get reading support from a personal tutor in one-to-one lessons or practise reading by yourself at your own speed with a self-study course.',
	'Reading practice to help you understand long, complex texts about a wide variety of topics, some of which may be unfamiliar. Texts include specialised articles, biographies and summaries.',
	'Reading practice to help you understand texts with a wide vocabulary where you may need to consider the writer\'s opinion. Texts include articles, reports, messages, short stories and reviews.',
	'Reading practice to help you understand texts with everyday or job-related language. Texts include articles, travel guides, emails, adverts and reviews.',
	'Reading practice to help you understand simple texts and find specific information in everyday material. Texts include emails, invitations, personal messages, tips, notices and signs.',
	'Take our free online English test to find out which level to choose. Select your level, from A1 English level (elementary) to C1 English level (advanced), and improve your reading skills at your own speed, whenever it\'s convenient for you.',
}

---@param provider TranslationProvider
return function (provider)
	return function ()
		local avg = require 'modules.average' (0, mp.get_time, 50)

		local delay = 0
		for _ = 1, 2 do
			for _, value in pairs(values) do
				avg:tick()

				pcall(provider.translate, value)

				delay = avg:tick()
				logger.info('Running...', delay)
			end
		end

		logger.info('Recommended delay is', delay)
		return delay
	end
end
