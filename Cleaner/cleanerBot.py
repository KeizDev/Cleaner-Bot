import discord
from discord.ext import commands
import asyncio
from colorama import init, Fore, Style
import os

os.system("cls")

init(autoreset=True)

TOKEN = input(Fore.CYAN + "Veuillez entrer le token du bot : ")
GUILD_ID = int(input(Fore.CYAN + "Veuillez entrer l'ID du serveur : "))
KEEP_CHANNEL_ID = int(input(Fore.CYAN + "Veuillez entrer l'ID du salon à garder : "))
NEW_ROLE_NAME = input(Fore.CYAN + "Veuillez entrer le nom du nouveau rôle : ")
intents = discord.Intents.default()
intents.members = True  # Nécessaire pour accéder aux membres
bot = commands.Bot(command_prefix="+", intents=intents)

@bot.event
async def on_ready():
    print(Fore.GREEN + f"\n{bot.user} est connecté au serveur.")
    
    guild = discord.utils.get(bot.guilds, id=GUILD_ID)
    if guild is None:
        print(Fore.RED + "Le serveur n'a pas été trouvé.")
        await bot.close()
        return

    deleted_channels = 0
    for channel in guild.channels:
        if channel.id != KEEP_CHANNEL_ID:
            try:
                await channel.delete()
                deleted_channels += 1
                print(Fore.YELLOW + f"Salon {channel.name} supprimé.")
            except Exception as e:
                print(Fore.RED + f"Erreur lors de la suppression du salon {channel.name}: {e}")

    deleted_roles = 0
    for role in guild.roles:
        if role.name != "@everyone":
            try:
                await role.delete()
                deleted_roles += 1
                print(Fore.YELLOW + f"Rôle {role.name} supprimé.")
            except Exception as e:
                print(Fore.RED + f"Erreur lors de la suppression du rôle {role.name}: {e}")

    try:
        new_role = await guild.create_role(name=NEW_ROLE_NAME)
        print(Fore.GREEN + f"Rôle {NEW_ROLE_NAME} créé avec succès.")
    except Exception as e:
        print(Fore.RED + f"Erreur lors de la création du rôle : {e}")
        await bot.close()
        return

    members_with_role = 0
    for member in guild.members:
        try:
            await member.add_roles(new_role)
            members_with_role += 1
        except Exception as e:
            print(Fore.RED + f"Erreur lors de l'attribution du rôle à {member.name}: {e}")

    channel = bot.get_channel(KEEP_CHANNEL_ID)
    if channel:
        await channel.send(
            f"🎉 **Opération terminée :**\n"
            f"🔹 Salons supprimés : **{deleted_channels}**\n"
            f"🔹 Rôles supprimés : **{deleted_roles}**\n"
            f"🔹 Rôle créé : **{NEW_ROLE_NAME}**\n"
            f"🔹 Membres ayant le rôle : **{members_with_role}**"
        )
    
    print(Fore.GREEN + "\nOpération terminée avec succès !")
    await bot.close()

bot.run(TOKEN)