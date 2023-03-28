return {
    {
        'numToStr/Comment.nvim',
        event = { 'VeryLazy' },
        config = function()
            require('Comment').setup({
                toggler = {
                    line = '<C-_>',
                },
                opleader = {
                    line = '<C-_>'
                },
            })
        end
    },
}
