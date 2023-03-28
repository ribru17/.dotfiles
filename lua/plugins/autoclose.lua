return {
    {
        'windwp/nvim-ts-autotag',
        ft = { 'html', 'xml', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx',
            'jsx', 'rescript', 'php', 'markdown', 'glimmer', 'handlebars', 'hbs'
        }
    },
    {
        'windwp/nvim-autopairs',
        event = { 'VeryLazy' },
        dependencies = {
            'hrsh7th/nvim-cmp'
        },
        config = function()
            require('nvim-autopairs').setup {}

            -- Insert `(` after select function or method item
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
        end
    },
}
