module(..., package.seeall)

overlay_logic = {  
            automated={  
                title='Automated',
                description='An automated tile cannot be activated by a human. Instead, it activates itself once every 10 years',
            },
            self_powered={
                title='Self-Powered',
                description='A self-powered tile does not need to be powered to operate.',
            },
            powered={
                title='Powered',
                description='Only powered tiles can be activated.',
            },
            activated={
                title='Activated',
                description='',
            },
        }

base_logic = {  
            empty={  
                title='Empty',
                description='There is no tile here.',
            },
            cafetoriax={
                title='Cafetoriax',
                description='Humans need food badly.',
                cost=5,
            },
            power={
                title='Power Plant',
                description='Randomly powers 3 tiles.',
                cost=15,
            },
            auto_power={
                title='Automated Power Plant',
                description='Randomly powers 3 tiles every 10 turns.',
                cost=80,
            },
            thresher={
                title='Thresher',
                description='Kills one human, then clogs until it is powered down and up again.',
                cost=5,
            },
            cryo={
                title='Cryo Chamber',
                description='Produces one human.',
                cost=10,
            },
            manufactorum={
                title='Manufactorm',
                description='Produces 1 coin when activated.',
                cost=10,
            },
        }

