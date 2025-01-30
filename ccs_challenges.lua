SMODS.Back {
    key = "fragile_deck",
    loc_txt = {
        name = "Fragile Deck",
        text = {
            "A deck",
            "of {C:attention}glass{} cards",
            "{C:mult}X3{} blind score"
        }
    },
    config = { ante_scaling = 3},
    apply = function(back)
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, card in ipairs(G.playing_cards) do
                    card:set_ability(G.P_CENTERS.m_glass)
                end
                return true
            end
        }))
    end
}

SMODS.Challenge {
    key = "fragility",
    loc_txt = {
        name = "Fragility",
    },
    rules = {
        custom = {
            {
                id = 'glass'
            }
        }
    },
    jokers = {
        {
            id = 'j_ccs_thebone',
            eternal = true,
        },
        {
            id = 'j_ccs_thefeather',
            eternal = true,
        },
    },
    deck = {
        enhancement = 'm_glass'
    }
}