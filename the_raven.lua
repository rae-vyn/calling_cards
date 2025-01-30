--[[
0 -> Claw
1 -> Beak
2 -> Bone
3 -> Eye
4 -> Feather
]]
SMODS.Atlas {key = "CC_ATLAS", px = 71, py = 95, path = "CC_ATLAS.png"}

-- The Claw
SMODS.Joker {
    key = 'theclaw',
    config = {extra = { mult = 5 } },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult} }
    end,
    rarity = 2,
    atlas = "CC_ATLAS",
    pos = {x = 0, y = 0},
    cost = 2,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.individual and not context.end_of_round then
            if #context.full_hand >= 4 then -- The # is the length operator in Lua.
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}

-- The Beak 
SMODS.Joker {
    key = "thebeak",
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.mult, card.ability.extra.curr_mult}}
    end,
    config = {extra = {mult = 5, curr_mult = 0}},
    rarity = 2,
    atlas = "CC_ATLAS",
    pos = { x = 1, y = 0},
    cost = 3,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.individual and not context.end_of_round then
            if context.other_card.ability.effect == 'Steel Card' or context.other_card.ability.effect == 'Gold Card' then -- Check if it's a steel/gold
                card.ability.extra.curr_mult = card.ability.extra.curr_mult + card.ability.extra.mult
            end
        end
        if context.joker_main and card.ability.extra.curr_mult > 0 then -- Make sure there's actually some mult to add.
            return {
                mult_mod = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
            }
        end
    end
}

-- The Bones
SMODS.Joker {
    key = "thebone",
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.mult} }
    end,
    config = { extra = {mult = 0}},
    rarity = 2,
    atlas = "CC_ATLAS", 
    pos = {x = 2, y = 0},
    cost = 4,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.discard and not context.blueprint then
            if context.other_card.ability.effect == 'Glass Card' then -- Check if it's a glass card
                --[[
                Even though face cards all have a chip value of 10,
                They have an actual numerical rank (Jack is 11, Queen is 12, etc.)
                ]]
                card.ability.extra.mult = card.ability.extra.mult + 2 * context.other_card:get_id()
                -- Since it's a glass card, we can call shatter() to destroy it.
                context.other_card:shatter()
                return { remove = true } -- return remove = true to actually delete the card
            end
        end
        if context.joker_main and card.ability.extra.mult > 0 then -- Make sure there's actually some mult to add.
            return {
                mult_mod = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
            }
        end
    end
}

-- The Eye
SMODS.Joker {
    key = "theeye",
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    config = { extra = { money = -9} },
    rarity = 3,
    atlas = "CC_ATLAS",
    pos = {x = 3, y = 0},
    cost = 4,
    blueprint_compat = false,
    calculate = function(self, card, context)
        -- We add `not context.blueprint` so blueprint doesn't retrigger it.
        if context.buying_card and not context.blueprint then
            -- Checks if the card is actually a Joker.
            if context.card.ability.set ~= 'Joker' then
                return
            end
            context.card:set_edition("e_negative")
            ease_dollars(card.ability.extra.money)
            -- This just adds a $-9 popup under the card.
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = '$'..card.ability.extra.money, colour = G.C.GOLD})
            return
        end
    end
}

-- The Feather
SMODS.Joker {
    key = "thefeather",
    config = {},
    rarity = 2,
    atlas = "CC_ATLAS",
    pos = {x = 4, y = 0},
    cost = 4,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.before then
            -- The number of cards that score.
            local hand_size = #context.scoring_hand 
            --[[ 
            Creates a copy of a playing card (That's why the G.playing_card is there)
            Since Lua uses 1-based indexing, we can just grab the card using the length of the array
            ]]
            local _card = copy_card(context.scoring_hand[hand_size], nil, nil, G.playing_card, true)
            -- Removes the seal and enhancement from the card
            _card:set_seal()
            _card:set_ability(G.P_CENTERS.c_base)
            _card:add_to_deck()
            -- Adds more room for the card
            G.deck.config.card_limit = G.deck.config.card_limit + 1
            -- Emplace the card into the deck so it doesn't hover onscreen.
            G.deck:emplace(_card)
            -- Add the card to the actual deck table
            table.insert(G.playing_cards, _card)

            return {
                message = "Copied!"
            }
        end
    end
}